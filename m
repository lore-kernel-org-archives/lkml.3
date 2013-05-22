Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3EVQhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:37:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39387 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543Ab3EVQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:37:22 -0400
Message-ID: <1369240640.2143.74.camel@joe-AO722>
Subject: Re: [PATCH] maintainers: Remove Kent from maintainers
From: Joe Perches <joe@perches.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        LeonidasDaSilvaBarbosa <leosilva@linux.vnet.ibm.com>,
        AshleyLai <ashley@ashleylai.com>
Date: Wed, 22 May 2013 09:37:20 -0700
In-Reply-To: <20130522155658.GA3740@ennui.austin.ibm.com>
References: <20130522155658.GA3740@ennui.austin.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 10:56 -0500, Kent Yoder wrote:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -3971,7 +3971,8 @@ S:	Maintained
>  F:	arch/ia64/
>  
>  IBM Power in-Nest Crypto Acceleration
> -M:	Kent Yoder <key@linux.vnet.ibm.com>
> +M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> +M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Supported
>  F:	drivers/crypto/nx/
> @@ -8212,7 +8213,8 @@ S:	Odd fixes
>  F:	drivers/media/usb/tm6000/
>  
>  TPM DEVICE DRIVER
> -M:	Kent Yoder <key@linux.vnet.ibm.com>
> +M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> +M:	Ashley Lai <ashley@ashleylai.com>
>  M:	Rajiv Andrade <mail@srajiv.net>
>  W:	http://tpmdd.sourceforge.net
>  M:	Marcel Selhorst <tpmdd@selhorst.net>

As far as I know, none of these people have
previously submitted a single patch.

None of them were cc'd neither. (now cc'd)

I think a better way to do this sort of
change is to have the people becoming
MAINTAINERS submit the patches and the
person departing ack it, or simply to
remove yourself and let other people add
themselves later.


