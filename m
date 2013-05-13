Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3EMH1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:27:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3EMH06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:26:58 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-c3-519095c08cf2
Date: Mon, 13 May 2013 07:26:56 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: Tony Luck <tony.luck@gmail.com>, Mike Galbraith <bitbucket@online.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130513072238106@eunb.song
Msgkey: 20130513072238106@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130513072238106@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17643170.28271368430013771.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Ztu6BqRMCDT4+lLe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZR2beYCn4wFZxd+c01gbGK2xdjJwcQgIqEi3/vzOC2BICJhIn
	es8zQ9hiEhfurQeq4QKqWcYosfrTRlaYov/vbjFDNM9nlOhsCgSxWQRUJZavPwRWwyagLfH2
	ywMwW1jATWLF7iawehEBf4mnn88wggxlFjgL1LvhC9QgeYnJpy+zg9i8AoISJ2c+YYFYpiTx
	5NYKFoi4skTnykaoIyQkZk2/AGXzSsxofwpVLycx7esaqA+kJc7P2sAI883i74+h4vwSx27v
	YOpi5ADrfXI/GGbM7s1f2CBsAYmpZw4yQpSoS6z4Kg8R5pNYs/AtC8yUXaeWM8O03t8ylwnE
	ZhZQlJjS/ZAdwtaS+PJjHxuqrziAbEeJ83P1JjAqz0KSmYWkexaSbmQ1CxhZVjGKphYkFxQn
	pRcZ6hUn5haX5qXrJefnbmKEJIXeHYy3D1gfYkwGxshEZinR5HxgUskriTc0NjOyMDUxNTYy
	tzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Ps6qO5mVIqWV6aF/0up4e9
	miUTe3ymNruo3CRFlbCbB25VmH2Ubdxmu/bET1Oen4rnNtpOuGklqiv7/MvFbVzpskoHJ83t
	q/+eLbxl6TzDEvlCqQ/dNh3X/t59PrVs6dmKpInr+a8deCe8SOL1jNbT13Z6Z8VNuTfL6ZTV
	8ktTrt4+vSV309+rSizFGYmGWsxFxYkAmiRoQCADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN0DUycEGlybIWtxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Mo7MvMFS8IGt4u7OaawNjFfYuhg5OYQEVCRa/n9nBLElBEwk/r+7xQxhi0lcuLceqmY+o0Rn
	UyCIzSKgKrF8/SFWEJtNQFvi7ZcHYLawgJvEit1NYL0iAv4STz+fAZrJxcEscBaod8MXZohB
	8hKTT19mB7F5BQQlTs58wgKxTEniya0VLBBxZYnOlY2sEHEJiVnTL0DZvBIz2p9C1ctJTPu6
	BupQaYnzszYwwhy9+PtjqDi/xLHbO5i6GDnAep/cD4YZs3vzFzYIW0Bi6pmDjBAl6hIrvspD
	hPkk1ix8ywIzZdep5cwwrfe3zGUCsZkFFCWmdD9kh7C1JL782MeG6isOINtR4vxcvQmMcrOQ
	ZGYh6Z6FpBtZzQJGllWMoqkFyQXFSekVRnrFibnFpXnpesn5uZsYwenp2aIdjP/OWx9iFOBg
	VOLhXaA8IVCINbGsuDL3EKMEB7OSCO9eN6AQb0piZVVqUX58UWlOavEhxmRg/E1klhJNzgem
	zrySeENjA2NDQ0tzA1NDIwvShJXEeZ+1WgcKCaQnlqRmp6YWpBbBbGHi4JRqYGx2XGfdy814
	vfPxh63Coc3fn6wR/WHTufKqlSE766l9lv+a3ddfe33m0q/dDSs7PGcvi78XfIln5SZleVut
	qwkMDG3TBQR13rz5+ffni4wnrkqf3zolfGJR9/oe/lBArerP9Wae2e61TTFfrIMc1Uxbnh2z
	UTuU9LkwJa1RSGnB4lfpX+yVZZRYijMSDbWYi4oTAaTRH9STAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4D7R66F031899



Hi,
I have some problem to boot with 3.10-rc1.  So i will test with e0fd9affeb64088eff407dfc98bbd3a5c17ea479.
The commit message is as follow.
commit e0fd9affeb64088eff407dfc98bbd3a5c17ea479
Merge: 3d15b79 ea9627c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 8 15:29:48 2013 -0700

    Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband


Usually, the problem was reproduced in 30 seconds in my board. 
I will test only revert ae4647fb7654676fc44a97e86eb35f9f06b99f66(jbd2: reduce journal_head size) and 
i will let you know the test result. 

Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
