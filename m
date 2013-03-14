Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838Ab3CNRmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:42:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44851 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3CNRmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:42:22 -0400
X-Originating-IP: 67.232.160.146
Date: Thu, 14 Mar 2013 10:42:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Message-ID: <20130314174216.GA2981@jtriplet-mobl1>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
 <20130314040835.GB11821@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314040835.GB11821@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:08:35AM -0400, Theodore Ts'o wrote:
> Huh.  This is very, very weird.  Is this a repeatable crash?

I could reliably replicate it for that particular session, but now that
I've rebooted the host, no.

- Josh Triplett
