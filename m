Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3B0Kpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:45:39 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:59555 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3B0Kpi (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 27 Feb 2013 05:45:38 -0500
Message-Id: <512DF1DF02000078000C16A4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 27 Feb 2013 10:45:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Chen Gang" <gang.chen@asianux.com>
Cc: <roger.pau@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used
 without initialized
References: <512D90F2.9070200@asianux.com>
 <512DE6B302000078000C1631@nat28.tlf.novell.com>
 <512DE213.3050001@asianux.com>
In-Reply-To: <512DE213.3050001@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.02.13 at 11:38, Chen Gang <gang.chen@asianux.com> wrote:
> 于 2013年02月27日 17:57, Jan Beulich 写道:
>> You also could have mentioned that even before commit 
>> 01c681d4c70d64cb72142a2823f27c4146a02e63 the value printed
>> here was bogus, as it was the guest provided value from
>> req->u.rw.handle rather than the actual device.
> 
>   pardon ?
> 
>   I guess what you said is :
>     my patch seems ok, but the comments need improving.
>     need add "additional info" in comments:
>       "before commit 01c681d4c70d64cb72142a2823f27c4146a02e63
>        the value printed here was bogus, as it was the guest
>        provided value from req->u.rw.handle rather than the
>        actual device".
> 
>   is it correct ?

Yes (and you might have missed the ACK that I had already sent
before this reply - that mail got bounced for your address).

Jan
