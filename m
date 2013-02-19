Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3BSPKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:10:54 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:57610 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3BSPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:10:52 -0500
Subject: Re: [PATCH] acer-wmi: do not use 'devices' uninitialized
From: joeyli <jlee@suse.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
In-Reply-To: <1361261230.26423.9.camel@x61.thuisdomein>
References: <1359033178.1325.15.camel@x61.thuisdomein>
	 <1361241494.6635.2.camel@linux-s257.site>
	 <1361261230.26423.9.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Feb 2013 23:09:47 +0800
Message-ID: <1361286587.6635.29.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-02-19 於 09:07 +0100，Paul Bolle 提到：
> Joey.
> 
> On Tue, 2013-02-19 at 10:38 +0800, joeyli wrote:
> > Zhang Rui sent similar patch for fix the warning:
> > http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg04016.html
> 
> I see. It didn't make it into the v3.8 release. Could someone please
> send a note to the stable list once Zhang's patch hits mainline
> (presumably in one of the v3.9 release candidates)?
> 
> 
> Paul Bolle
> 
> .

I will track this patch and send the note to stable kernel when it
merged to platform driver git.


Thanks a lot!
Joey Lee

