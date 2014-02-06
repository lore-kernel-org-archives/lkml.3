Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaBFEwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:52:04 -0500
Received: from nctlincom02.orcon.net.nz ([60.234.4.76]:57602 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBFEwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:52:02 -0500
X-Greylist: delayed 800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 23:52:02 EST
Date: Thu, 6 Feb 2014 17:38:33 +1300
From: Michael Cree <mcree@orcon.net.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH 3.12 117/133] alpha: fix broken network checksum
Message-ID: <20140206043833.GA12599@omega>
References: <20140204210737.008598235@linuxfoundation.org>
 <20140204210740.336662867@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204210740.336662867@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Check: by mx6.orcon.net.nz on Thu, 06 Feb 2014 17:38:38 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Feb  6 17:38:38 2014
X-DSPAM-Confidence: 0.6515
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05LmQCCfu - 6bebdd82f3c9 - 20140206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 01:08:38PM -0800, Greg Kroah-Hartman wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> commit 0ef38d70d4118b2ce1a538d14357be5ff9dc2bbd upstream.
> 
> The patch 3ddc5b46a8e90f3c9251338b60191d0a804b0d92 breaks networking on
> alpha (there is a follow-up fix 5cfe8f1ba5eebe6f4b6e5858cdb1a5be4f3272a6,
> but networking is still broken even with the second patch).

I wonder whether that follow-up (partial) fix mentioned
(5cfe8f1ba5eebe6f4b6e5858cdb1a5be4f3272a6) should be pulled into 3.12 stable
too?

Cheers
Michael.
