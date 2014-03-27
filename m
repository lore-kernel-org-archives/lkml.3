Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaC0BEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:04:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaC0BEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:04:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RESEND for ARM-SoC 0/2] ARM: STi: NOR Flash support
Date: Thu, 27 Mar 2014 02:04:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, kernel@stlinux.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@st.com
References: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403270204.42583.arnd@arndb.de>
X-Provags-ID: V02:K0:Jyk3rOdXUWyogwYcKGSSbL/ynjLpd36pFAarkRcqMwy
 wQ8Ftgg9MYNo/vHKG03StYanb3eZxECAqrdKPPWsk+01gKOs/3
 v7yCAQxorijeHWpNRo3vhXX8UIkuduij3Ex2e0U8eMpdJUaweG
 ZQO2WvgXXmQzSOrj9cuuup+39P/u6Z6HnPg/5XucnYEg8MvH+h
 roWRachgEAnzZgBJBCsOU8JNviYhDL5HDcYRl5ti9IV2w307N+
 PfMbgxQTOA3TrzFYogeLuGcUum95NzGv+lA27QN9ld6/ZW6HkV
 JP0Y8J86pNP0+GNows+MKhoqA8n/Jr6Nx1n0nw9jSl716QbQbg
 Avrhh38HE5AwNh0p16PsjmOjTIN906AhKkfMmiMI1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2014, Lee Jones wrote:
> As requested by Arnd:
> 
> ARM-SoC Maintainers,
> 
> Please apply these two patches directly to ARM-SoC for inclusion
> into the v3.15 merge window. All maintainer Acks are applied.
> 
> Kind regards,

Applied to next/dt branch. I had a trivial conflict against the
addition of the network device nodes, which I resolved on this
branch.

Thanks,

	Arnd
