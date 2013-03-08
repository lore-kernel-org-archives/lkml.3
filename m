Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab3CHXOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:14:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863Ab3CHXOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:14:32 -0500
Date: Fri, 8 Mar 2013 18:14:29 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308231429.GB28317@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130308150408.GA25399@redhat.com>
 <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
 <20130308192042.GA10305@redhat.com>
 <20130308193652.GA11692@redhat.com>
 <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com>
 <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308230734.GA28317@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 06:07:34PM -0500, Dave Jones wrote:
 > parent seems to be a pointer to "\0".

Ignore that last part, it's wrong.

	Dave

