Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaFNIxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 04:53:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54849 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaFNIxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 04:53:36 -0400
Date: Sat, 14 Jun 2014 10:53:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali Roh?r <pali.rohar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH v2] Documentation: Rename hpfall.c => freefall.c, fixes
 for Dell
Message-ID: <20140614085328.GC15326@Nokia-N900>
References: <1399114077-19314-3-git-send-email-pali.rohar@gmail.com>
 <1402473727-5464-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402473727-5464-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-11 10:02:07, Pali Roh?r wrote:
> Dell kernel driver dell-smo8800 provides same freefall interface as hp_accel so
> program hpfall.c works also on Dell laptops. So rename it to freefall.c.
> 
> Dell driver does not provide hp::hddprotect led so make sure that freefall.c
> works also if hp::hddprotect does not exist in sysfs.
> 
> Additionally write info to syslog.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: Sonal Santan <sonal.santan@gmail.com>
> ---
> Changes since v1:
> * Fixed warnings: Missing a blank line after declarations
> ---
>  Documentation/laptops/00-INDEX   |    4 +-
>  Documentation/laptops/freefall.c |  177 ++++++++++++++++++++++++++++++++++++++
>  Documentation/laptops/hpfall.c   |  146 -------------------------------
>  3 files changed, 179 insertions(+), 148 deletions(-)
>  create mode 100644 Documentation/laptops/freefall.c
>  delete mode 100644 Documentation/laptops/hpfall.c

Acked-by: Pavel Machek <pavel@ucw.cz>

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
