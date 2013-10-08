Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3JHJ5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab3JHJ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:57:29 -0400
Message-ID: <5253D705.6060400@redhat.com>
Date: Tue, 08 Oct 2013 11:57:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, dzickus@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] generic kernel watchdog reset at pvclock read
References: <20131008010515.516032211@amt.cnet>
In-Reply-To: <20131008010515.516032211@amt.cnet>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/10/2013 03:05, Marcelo Tosatti ha scritto:
> See individual patches for details.

Looks good.

Perhaps you want to swap the two patches, so that patch 1 also includes
the call to reset_hung_task_detector?

If it goes through the KVM tree, I guess we need an Acked-by for the
hung_task part.  If it goes through someone else, you can add my
Acked-by to the pvclock part.

Paolo
