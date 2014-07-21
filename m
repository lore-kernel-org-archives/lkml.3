Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaGULhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:37:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36460 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaGULhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:37:20 -0400
Date: Mon, 21 Jul 2014 04:36:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Sam Ravnborg <sam@ravnborg.org>, pramod.gurav.etc@gmail.com,
        Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] direct-io: fix uninitialized warning in do_direct_IO()
Message-ID: <20140721113653.GC2628@infradead.org>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
 <20140713115022.GA6054@infradead.org>
 <53C6B199.2070606@gmail.com>
 <20140716175803.GA3631@infradead.org>
 <1405536124.4357.17.camel@x41>
 <53C79949.7010201@gmail.com>
 <53C7AF58.5030807@gmail.com>
 <1405596599.5735.11.camel@x41>
 <53CB8730.40607@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CB8730.40607@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

While it looks obvious, did you make sure it passes xfstests, which
has a lot of direct I/O tests?

