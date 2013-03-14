Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3CNEIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:08:43 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53314 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3CNEIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:08:41 -0400
Date: Thu, 14 Mar 2013 00:08:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Message-ID: <20130314040835.GB11821@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313191016.GA1793@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huh.  This is very, very weird.  Is this a repeatable crash?

      	      	    	 	    	 - Ted
