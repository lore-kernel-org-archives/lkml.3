Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaENJRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:17:39 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60354 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaENJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:17:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
Date: Wed, 14 May 2014 11:17:24 +0200
Message-ID: <8309592.drxAj71PnZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400055865.31197.4.camel@x220>
References: <1364507176.1345.45.camel@x61.thuisdomein> <1400055865.31197.4.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:l/jyxt1OMd5otKj1vol/a+tXEGNLawOWFX95SYWHke1
 Qi2ki2s60rVMXjcFs+sSRouG6o4SpqB6bgt+Aci3so3yqonWa7
 epSer3b+wDt4votTKlJF/k5q7itpxp3YrP30V8qTC2+zDZ7rIa
 lOdiqQgh0qDEu8Q8hCqbG5kdojOa72x6fklYMowH5rEwLAl3km
 UqS0lzKXxpdxgz2V9GCjx9cw7i2hPQQIMJf/N5E0hH7/hySfD8
 vCbI8xa9dFLPx5GNqLOQ5QrE0tTtJBT6RSJQKfg6eTdd7CZ0oU
 3wzDSJLYMEOKf9JcElTmVrPvQR0DdZOS6H7A+Se7UO6mzEBtXy
 p3oaQxm0ebM5qfYMIg88=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 10:24:25 Paul Bolle wrote:
> Support for ARM710 CPUs was removed in v3.5. Now remove the last code
> depending on its Kconfig macro.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> First submitted in March 2103. Still untested. Please note that
> cpu_arm7_data_abort was also removed in v3.5.
> 

'git grep -i arm710' tells me that there is also some arm710
specific code in  arch/arm/mm/proc-arm720.S that we may want to
remove along with this.

The DT binding should probably remain untouched though, I think it's
correct to document the string.

	Arnd
