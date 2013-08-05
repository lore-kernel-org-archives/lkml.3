Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3HEWwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:52:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab3HEWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:52:10 -0400
Message-ID: <52002C49.1060201@zytor.com>
Date: Mon, 05 Aug 2013 15:50:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 0/18] Paravirtualized ticket spinlocks
References: <20130722061631.24737.75508.sendpatchset@codeblue>
In-Reply-To: <20130722061631.24737.75508.sendpatchset@codeblue>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, having read through the entire thread I *think* this is what the
status of this patchset is:

1. Patches 1-17 are noncontroversial, Raghavendra is going to send an
   update split into two patchsets;
2. There are at least two versions of patch 15; I think the "PATCH
   RESEND RFC" is the right one.
3. Patch 18 is controversial but there are performance numbers; these
   should be integrated in the patch description.
4. People are in general OK with us putting this patchset into -tip for
   testing, once the updated (V12) patchset is posted.

If I'm misunderstanding something, it is because of excessive thread
length as mentioned by Ingo.

Either way, I'm going to hold off on putting it into -tip until tomorrow
unless Ingo beats me to it.

	-hpa

