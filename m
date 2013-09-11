Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3IKIRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:17:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40365 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IKIRd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 11 Sep 2013 04:17:33 -0400
Message-Id: <5230433A02000078000F24CC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 11 Sep 2013 09:17:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/5] xen: xensyms support
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
 <1378827110-4192-2-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1378827110-4192-2-git-send-email-boris.ostrovsky@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.09.13 at 17:31, Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -242,4 +242,9 @@ config XEN_MCE_LOG
>  config XEN_HAVE_PVMMU
>         bool
>  
> +config XEN_SYMS
> +       bool "Xen symbols"
> +       depends on XEN_DOM0 && XENFS && KALLSYMS
> +       default y

Looking through the rest of the patch I can't see the dependency
on KALLSYMS. Perhaps this should be used for the default setting
instead of as a dependency?

Jan

