Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3LELWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab3LELWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:22:07 -0500
Date: Thu, 5 Dec 2013 12:21:58 +0100
From: Karel Zak <kzak@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Domsch <Matt_Domsch@dell.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "Chandramouleeswaran,Aswin" <aswin@hp.com>
Subject: Re: [PATCH] partitions/efi: complete gpt kernel param purpose
Message-ID: <20131205112158.GD8058@x2.net.home>
References: <1386198962.31494.12.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386198962.31494.12.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:16:02PM -0800, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> The usage of the 'gpt' kernel parameter is twofold:
> (i) skip any mbr integrity checks and (ii) enable the
> backup GPT header to be used in situations where the
> primary one is corrupted. This last "feature" is not
> obvious and needs to be properly documented in the
> kernel-parameters document.

The question is if we really have to force users to specify "gpt"
kernel parameter to use the backup GPT header. Maybe it would be
enough to report the problem (print warning) and use the valid backup
header. IMHO the current behaviour is overkill.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
