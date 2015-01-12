Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbbALIJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:09:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52724 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:09:13 -0500
Date: Mon, 12 Jan 2015 09:09:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: power: snapshot: Remove unused function
Message-ID: <20150112080910.GB27501@amd>
References: <1421015258-24472-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421015258-24472-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-11 23:27:38, Rickard Strandqvist wrote:
> Remove the function get_safe_write_buffer() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Pavel Machek <pavel@ucw.cz>

Rafael should take this, I guess...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
