Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbaH0KJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:09:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbaH0KJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:09:47 -0400
Message-ID: <53FDAE65.3080208@redhat.com>
Date: Wed, 27 Aug 2014 12:09:41 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH v3 part1 0/4] Fix SG_IO ambiguity between READ SUBCHANNEL
 and UNMAP (and other similar cases)
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com> <20140827093437.GA10937@hercules>
In-Reply-To: <20140827093437.GA10937@hercules>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/08/2014 11:34, Luis Henriques ha scritto:
> > The SG_IO ioctl's command whitelist is designed for MMC devices (roughly,
> > "play/burn CDs without requiring root") but some opcodes overlap across SCSI
> > device classes and have different meanings for different classes.
> > 
> > To fix this, use different bitmaps for the various device classes.
> > This is CVE-2012-4542.
>
> Sorry for bringing this old issue again, but I was wondering what
> happen to this fix.

Nothing; everybody lost interest in it.

Paolo
