Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3JJQbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:31:55 -0400
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:55776 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3JJQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:31:53 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2013 12:31:53 EDT
Date: Thu, 10 Oct 2013 18:25:35 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-kernel@vger.kernel.org
Subject: per block device cache use adjustable?
Message-ID: <20131010162535.GA12986@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a 4.7 GB 4x DVD+RW I did:
(Fedora 19, x86_64, 4GB RAM)

mkudffs /dev/sr0
mount /dev/sr0 /dvd0
dd if=some-4gb-file of=/dvd0/bigfile.bin

After a few seconds ls -l /dvd0/bigfile.bin displayed 600 MB which
means that more than 30 seconds are kept in RAM.

Is it possible to limit the write cache to a sane value
for this specific device? (perhaps a few seconds at 2..3 MB/sec
write speed)

Thanks in advance for anything helpful,

Karl

PS: dd oflag=direct helps of course but I would like to have
a tuning knob to play with to get optimal performance in my
situation.

