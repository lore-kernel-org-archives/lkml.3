Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaICQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:25:33 -0400
Received: from syn.loicp.eu ([176.31.96.212]:51749 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaICQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:25:31 -0400
Date: Wed, 3 Sep 2014 18:25:28 +0200
From: Loic Pefferkorn <loic@loicp.eu>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] staging: goldfish: document spinlock usage
Message-ID: <20140903162528.GA1733@iron>
Mail-Followup-To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	gregkh@linuxfoundation.org, alan@linux.intel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1409742827-6048-1-git-send-email-loic@loicp.eu>
 <1409742827-6048-4-git-send-email-loic@loicp.eu>
 <20140903131319.79095a43@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140903131319.79095a43@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:13:19PM +0100, One Thousand Gnomes wrote:
> 
> This tells the reader nothing. It's good to document locking models but
> 
> - you lock data not code (which is a detail a lot of programmers get wrong
> 			  in th design stage too)
> - you need to document what objects are protected by the lock
> 
> 
> So it should tell the reader what the lock must be held to do
> 
> If you look at the audio code it actually protects the status field and
> status register of the "hardware"

Hello,

Thank you for the feedback, I will send a v2.

-- 
Cheers,
Loïc
