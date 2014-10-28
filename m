Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaJ1OTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:19:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58941 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaJ1OTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:19:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: rmk+kernel@arm.linux.org.uk, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/5] ARM: introduce a CONFIG_ARCH_MULTIPLATFORM_STRICT Kconfig option
Date: Tue, 28 Oct 2014 15:18:48 +0100
Message-ID: <71099905.SGyci24BjF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414503095-25986-2-git-send-email-kaixu.xia@linaro.org>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <1414503095-25986-2-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/8eCyekMS0cO2c2rFV26tdjALytMvons9hXGtKyyQOB
 uUr5rqvEUWZVUStvvTBKJjatDItG2oyqtK+C50xvtKag3PavI0
 JLKOtxxYsxaMzblst5LQO+rZEnzg4/UGBUs2l4qGptxuWEb68X
 rtOBBGbThkagR9g4Lrbm+0MVgyYExjO5cWabxgc/0Rx9kxzUVi
 NKrLcvNX1qw94Cvg0iyyMVuyHD73k5zvCWparVKeg1JLygANtz
 peM2x5hz33qO+xmn1afMnzCtD4TAmTbnHRECapXoqz3GHmM/hs
 6TIrmTNdI3s/0BCgawEl2n7DlozH4zEXs+HjLSXEsvKMCyOit+
 rwwPJDRbyOOzKXVUzRy0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 21:31:31 Xia Kaixu wrote:
>  endmenu
>  
> +config ARCH_MULTIPLATFORM_STRICT
> +        bool "Only allow options that do not break other platforms"
> +        depends on ARCH_MULTIPLATFORM
> +        default y
> +       help
> +          There are several configuration options that can only work
> 

Something seems to be wrong with the whitespace here. Please use tab
characters for indentation like we do elsewhere in the file.

Otherwise looks good, I think this is a good step in the right direction.

	Arnd
