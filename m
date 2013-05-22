Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3EVOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:12:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab3EVOMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:12:18 -0400
Message-ID: <519CD234.40608@redhat.com>
Date: Wed, 22 May 2013 16:12:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org>
In-Reply-To: <20130522134134.GA15189@mtj.dyndns.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/05/2013 15:41, Tejun Heo ha scritto:
> On Wed, May 22, 2013 at 12:23:56PM +0200, Paolo Bonzini wrote:
>> Yes, because I have no idea what _your_ point is.
> 
> Isolate the actual fixes and just submit them as it seems impossible
> for you to provide proper justifications for the things you want to
> add.

Quoting myself on January 26, 2013: "The vast majority of the commands
are added because Linux itself is using them".

Paolo
