Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaBLSEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:04:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaBLSEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:04:10 -0500
Date: Wed, 12 Feb 2014 13:03:56 -0500
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [3.13.2] list passed to list_sort() too long for efficiency.
Message-ID: <20140212180356.GA28354@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
References: <1799469.xr2i5c36Hj@localhost.localdomain>
 <1392227186.1868.20.camel@joe-AO722>
 <4850975.2GAlrTXDHt@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4850975.2GAlrTXDHt@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:59:07PM +0100, Paweł Sikora wrote:
 > On Wednesday 12 of February 2014 09:46:26 Joe Perches wrote:
 > > On Wed, 2014-02-12 at 18:16 +0100, Paweł Sikora wrote:
 > > > [16855.582522] list passed to list_sort() too long for efficiency
 > > > 
 > > > could someone put some light on the last line?
 > > 
 > > Did you look at the list_sort function in lib/list_sort.c?
 > > 
 > > (granted the dmesg is harder to find that it should be
 > >  because the format is split)
 > > 
 > > It just means it's slower than it could otherwise be
 > 
 > thanks,
 > so without a stacktrace in dmesg we can't isolate a root of cause :/

The commit message mentions xfs and ubifs have long lists that get
passed in. Do you use either of those ?

	Dave


