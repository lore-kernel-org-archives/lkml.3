Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbaGQLaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:30:05 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:57492 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbaGQLaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:30:03 -0400
Message-ID: <1405596599.5735.11.camel@x41>
Subject: Re: [PATCH v2] direct-io: squelch maybe-uninitialized warning in
 do_direct_IO()
From: Paul Bolle <pebolle@tiscali.nl>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
        Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        pramod.gurav.etc@gmail.com, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 13:29:59 +0200
In-Reply-To: <53C7AF58.5030807@gmail.com>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
		 <20140713115022.GA6054@infradead.org> <53C6B199.2070606@gmail.com>
		 <20140716175803.GA3631@infradead.org> <1405536124.4357.17.camel@x41>
	 <53C79949.7010201@gmail.com> <53C7AF58.5030807@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2014 11:30:00.0084 (UTC) FILETIME=[71B2FD40:01CFA1B2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh schreef op do 17-07-2014 om 14:11 [+0300]:
> From: Paul Bolle <pebolle@tiscali.nl>

Thanks for dropping my Signed-off-by tag.

Would you mind also dropping the From: line? I prefer you to also be
author of this patch.

Note that I'm pretty sure I can't claim copyright on the three chunks of
changes to the code nor on the few lines you copied into the commit
explanation. Besides, I'm perfectly OK with you using them in your patch
(especially since you've done review etc.).


Paul Bolle

