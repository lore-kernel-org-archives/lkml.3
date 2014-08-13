Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaHMKFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:05:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaHMKFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:05:00 -0400
Message-ID: <53EB384B.4090801@suse.com>
Date: Wed, 13 Aug 2014 12:04:59 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com>	<53EB3014.8090008@citrix.com> <53EB3337.3030809@suse.com> <53EB35F1.6000208@citrix.com>
In-Reply-To: <53EB35F1.6000208@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 11:54 AM, David Vrabel wrote:
> On 13/08/14 10:43, Juergen Gross wrote:
>>
>> static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t
>> ring_ref,
>>                          evtchn_port_t evtchn)
>> {
>> ...
>>          irq = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
>>          request_threaded_irq(irq, NULL, scsiback_irq_fn,
>>                               IRQF_ONESHOT, "vscsiif-backend", info)
>> ...
>
> This usage is fine.
>
> I assume the error checking of bind_interdomain_evtchn_to_irq() and
> request_threaded_irq() was omitted for clarity in this example?

Sure.


Juergen
