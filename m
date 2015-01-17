Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbbAQK6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:58:48 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41013 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbAQK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:58:46 -0500
Date: Sat, 17 Jan 2015 02:58:43 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/8] Coding Style Correction.
Message-ID: <20150117105843.GA11626@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Shailendra Verma <shailendra.capricorn@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1421481529-19304-1-git-send-email-shailendra.capricorn@gmail.com>
 <20150117101547.GA1952@hudson.localdomain>
 <CA+tKcn_U-5bH8=1MQJXepvz0iXV01xeSCikKJko6XbpFYAk5FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+tKcn_U-5bH8=1MQJXepvz0iXV01xeSCikKJko6XbpFYAk5FA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shailendra,

On Sat, Jan 17, 2015 at 03:51:49PM +0530, Shailendra Verma wrote:
> Hello Mahler,
> 
> I have just changed the coding style violations in this patch as described
> in the coding style Linux Documentation.
> 
Be specific about exactly what type of violation you fixed.
Was it white space fixes?  Was it indentation of cases statements?

> Thanks & Regards,
> Shailendra
> On Jan 17, 2015 3:45 PM, "Jeremiah Mahler" <jmmahler@gmail.com> wrote:
> 
> > Shailendra,
> >
> > Please describe in detail which specific coding issues you fixed.
> > I am not good at reading minds :-)
> >
> > Also, this is patch 8/8, and I see there is a 2/2, (which also needs
> > a better description).  Where are the rest of the patches?
> >
> > On Sat, Jan 17, 2015 at 01:28:49PM +0530, Shailendra Verma wrote:
> > >
> > > Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> > > ---
> > >  drivers/input/evdev.c    |   30 ++++++++++++++++++++----------
> > >  drivers/input/mousedev.c |   18 ++++++++++++------
> > >  2 files changed, 32 insertions(+), 16 deletions(-)
> > [...]
> >
> > --
> > - Jeremiah Mahler
> >

-- 
- Jeremiah Mahler
