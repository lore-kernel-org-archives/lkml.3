Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3KEKhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:37:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3KEKhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:37:19 -0500
Message-ID: <5278CA40.8080609@redhat.com>
Date: Tue, 05 Nov 2013 11:36:48 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com> <20120613013549.GO22848@dastard> <20120613033052.GT22848@dastard> <4FD82F89.80106@redhat.com> <20131105103435.GA24387@infradead.org>
In-Reply-To: <20131105103435.GA24387@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/11/2013 11:34, Christoph Hellwig ha scritto:
> On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
>> Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
>> leave for holiday soon).
> 
> Did you ever get back to this?

I have some patches for both kernel and xfstests, but I never got round
to testing them properly.  I don't think I'll have time soon to finish
that, but I might coerce someone into doing it.

Paolo
