Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaFMUjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:39:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaFMUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:39:07 -0400
Date: Fri, 13 Jun 2014 22:39:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86, kaslr: boot-time selectable with
 hibernation
Message-ID: <20140613203905.GA24635@amd.pavel.ucw.cz>
References: <1402691436-20138-1-git-send-email-keescook@chromium.org>
 <1402691436-20138-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402691436-20138-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-13 13:30:36, Kees Cook wrote:
> Changes kASLR from being compile-time selectable (blocked by
> CONFIG_HIBERNATION), to being boot-time selectable (with hibernation
> available by default) via the "kaslr" kernel command line.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
