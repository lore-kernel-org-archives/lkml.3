Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaBZRUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:20:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaBZRUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:20:34 -0500
Date: Wed, 26 Feb 2014 12:20:10 -0500
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226172010.GA9990@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
 <20140226131852.GA22690@pd.tnic>
 <20140226154949.GA770@redhat.com>
 <20140226171817.GB22690@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226171817.GB22690@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:18:17PM +0100, Borislav Petkov wrote:
 > On Wed, Feb 26, 2014 at 10:49:49AM -0500, Dave Jones wrote:
 > > I'd suggest repurposing 'S'. Instead of 'unsafe smp', it could mean
 > > "out of Spec". We currently only use that flag on some ancient athlon
 > > xp, so there's not going to be any kind of collision.
 > 
 > Hahaa, I said that yesterday already:
 > 
 > http://lkml.kernel.org/r/20140225113524.GA23256@pd.tnic

Then it's definitely a good idea :-)

	Dave

 
