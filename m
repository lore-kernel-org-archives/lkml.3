Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3IFLKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:10:10 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55245 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3IFLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:10:05 -0400
Date: Fri, 6 Sep 2013 15:09:29 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Baoquan He <baoquan.he@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.11.0-next-20130905: kernel BUG at include/linux/pagemap.h:343
Message-ID: <20130906110929.GA22621@cpv436-motbuntu.spb.ea.mot-mobility.com>
Mail-Followup-To: Baoquan He <baoquan.he@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <5229839A.1000000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5229839A.1000000@gmail.com>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 03:26:18PM +0800, Baoquan He wrote:
> [   30.438555] ------------[ cut here ]------------
> [   30.443385] kernel BUG at include/linux/pagemap.h:343!

Seems to be the same one I reported here:
http://www.spinics.net/lists/kernel/msg1597973.html

-- 
Regards,
    Artem
