Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3JDOA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:00:58 -0400
Received: from verein.lst.de ([213.95.11.211]:49263 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3JDOA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:00:57 -0400
Date: Fri, 4 Oct 2013 16:00:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004140054.GA7088@lst.de>
References: <20131003174439.GG13318@ZenIV.linux.org.uk> <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com> <20131003194351.GK13318@ZenIV.linux.org.uk> <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com> <20131003204142.GL13318@ZenIV.linux.org.uk> <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com> <20131003211448.GN13318@ZenIV.linux.org.uk> <20131004025351.GO13318@ZenIV.linux.org.uk> <20131004083729.GA23116@lst.de> <20131004125843.GP13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004125843.GP13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That patch looks fine to me. Having the s_readonly_remount infrastructure
around certainly makes things easier.
