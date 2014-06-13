Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaFMPKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:10:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39711 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaFMPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:10:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-cb-539b14679075
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: ming.lei@canonical.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/1] read firmware size using i_size_read()
Date: Fri, 13 Jun 2014 18:09:53 +0300
Message-id: <cover.1402672110.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xa7rpIrODDQ63mFnc+ruX2eLL0jqL
	5sXr2Swu75rDZrHr4Xd2B1aPWQ29bB47Z91l99g/dw27R9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGXcfbOepeA5U8WnbSdZGxjnMHUxcnBICJhIdH6t7mLkBDLFJC7cW8/WxcjFISSwlFHi
	6c71zBBOJ5PEvCvf2ECq2AT0JDY0/2AHsUUEpCR693Qyg9jMAs2MEjev+IDYwgJ2Etf3HGAC
	sVkEVCVubtnPAmLzClhKzPh9lB1im5zEyWOTWUFsToFgiZZHi8HmCwkESGyds4ltAiPvAkaG
	VYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh4fNlB+PiY1aHGAU4GJV4eD9UzwoWYk0sK67M
	PcQowcGsJMJ7rwEoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTH48ePn66U/BcjvWei/sp3lNuO6
	WB/7eZJRkgUKUjt67Byypn/cw+P5p+O208Nr9vvnTRBKnuo3XfYn02FHn65nQu29m3ukrb+q
	Hn+zQdaLg+FHo5mfqsXdnOSJDcdl56yMfXh1Z8HJHNUDgs9kct6UvnLPrOK4n3NsTVqrdllS
	495t+e0rMpVYijMSDbWYi4oTAfbzyjr9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You are right about file type.
inode structure also contains information about file type..
There is no need to use vfs_getattr().

Thanks,
Dmitry

Dmitry Kasatkin (1):
  firmware: read firmware size using i_size_read()

 drivers/base/firmware_class.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

-- 
1.9.1

