Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbbAQLUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:20:02 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53679 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbbAQLT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:19:59 -0500
Date: Sat, 17 Jan 2015 03:19:55 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Coding Style Correction.
Message-ID: <20150117111955.GA1842@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Shailendra Verma <shailendra.capricorn@gmail.com>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1421481529-19304-1-git-send-email-shailendra.capricorn@gmail.com>
 <20150117101547.GA1952@hudson.localdomain>
 <CA+tKcn_U-5bH8=1MQJXepvz0iXV01xeSCikKJko6XbpFYAk5FA@mail.gmail.com>
 <20150117105843.GA11626@hudson.localdomain>
 <CA+tKcn--30rOiU+aefNAP+LO3+dotADqemLM9-51Mxh150Qzfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+tKcn--30rOiU+aefNAP+LO3+dotADqemLM9-51Mxh150Qzfw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 04:43:01PM +0530, Shailendra Verma wrote:
> Hello Mahler,
> 
> I have fixed indentation violation in switch statement : aligned the
> "switch" and its subordinate "case" labels in the same column instead of
> "double-intending" the "case" labels.
> 
It is looking better.  Now put this in the patch log message and send
version 2.

> Thanks & Regards,
> Shailendra
> On Jan 17, 2015 4:28 PM, "Jeremiah Mahler" <jmmahler@gmail.com> wrote:
> 
> > Shailendra,
> >
[...]

-- 
- Jeremiah Mahler
