Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaFPR2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:28:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaFPR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:28:07 -0400
Message-ID: <539F2926.4020004@infradead.org>
Date: Mon, 16 Jun 2014 10:28:06 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
CC: linux-media <linux-media@vger.kernel.org>
Subject: MANY errors while building media docbooks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Linux v3.16-rc1, building docbooks to a separate build directory
(mkdir DOC; make O=DOC htmldocs) gives me more than 12,000 lines like this:

grep: ./Documentation/DocBook//vidioc-subdev-g-fmt.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subdev-g-frame-interval.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subdev-g-selection.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subscribe-event.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-device-info.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-enum-entities.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-enum-links.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-setup-link.xml: No such file or directory

-- 
~Randy
