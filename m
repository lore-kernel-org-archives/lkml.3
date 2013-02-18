Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3BRKFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:05:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3BRKFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:05:44 -0500
Message-ID: <5121FCD9.6010705@redhat.com>
Date: Mon, 18 Feb 2013 11:05:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: linux-kernel@vger.kernel.org, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com
Subject: Re: [PATCH v3 0/5] virtio-scsi multiqueue
References: <1360674391-2661-1-git-send-email-pbonzini@redhat.com> <5121F521.6080300@cn.fujitsu.com>
In-Reply-To: <5121F521.6080300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/02/2013 10:32, Wanlong Gao ha scritto:
>> > Ok for 3.9?  It would probably be easier to get it in via Rusty's tree
>> > because of the prerequisites.  James, can I get your Acked-by?
> I can't apply this series on top of Rusty's virtio-next, I missed something
> or needed rebase them ?

It's on top of the patches at
http://permalink.gmane.org/gmane.linux.kernel.virtualization/18431.

Paolo
