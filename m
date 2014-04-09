Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaDIKPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:15:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDIKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:15:37 -0400
Message-Id: <201404091015.s39AFQAu022348@aserz7021.oracle.com>
Date: Wed, 09 Apr 2014 06:15:23 -0400
Subject: Re: [LINUX PATCH 2/2] xen/pvhvm: Support more than 32 VCPUs when
 migrating.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel@lists.xenproject.org, konrad@kernel.org, david.vrabel@Citrix.com,
        boris.ostrovsky@oracle.com, keir@xen.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s39AFjC9017871


On Apr 9, 2014 4:03 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
> >>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote: 
> > + /* Only Xen 4.5 and higher supports this. */ 
> > + if (HYPERVISOR_vcpu_op(VCPUOP_is_up, smp_processor_id(), NULL) == -ENOSYS) 
> > + vcpuops = false; 
>
> Did you mean to say "for HVM guests" in the comment? And of 
> course the comment could quickly become stale if we backported 
> the Xen side change to e.g. 4.4.1. 
>

Right. But I thought that features like that (new hypercalls) wasn't applicable for backporting?

Thabksy
> Jan 
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
