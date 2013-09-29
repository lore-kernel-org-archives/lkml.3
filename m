Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3I2XHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:07:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37263 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab3I2XHS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:07:18 -0400
Message-ID: <1380496031.14493.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 062/117] ext4: fix ext4_writepages() in presence of truncate
From: Ben Hutchings <ben@decadent.org.uk>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Zheng Liu <gnehzuil.liu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 30 Sep 2013 00:07:11 +0100
In-Reply-To: <20130925001747.625543023@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
	 <20130925001747.625543023@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 17:18 -0700, Greg Kroah-Hartman wrote:
> 3.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit 5f1132b2ba8c873f25982cf45917e8455fb6c962 upstream.
[...]

Is this needed for any older kernel versions?

Ben.

-- 
Ben Hutchings
Life is like a sewer:
what you get out of it depends on what you put into it.
