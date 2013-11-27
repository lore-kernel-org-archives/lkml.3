Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3K0O2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:28:36 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:39561 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3K0O23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:28:29 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 0/2] ceph: Add clean up if invalid osd reply received
Date: Wed, 27 Nov 2013 22:28:12 +0800
Message-Id: <cover.1385561919.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUhNVU9JQkJCTU9CS09MQ05KTVdZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBTlVJTk1ANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkNTQkMj
	UkMz46Pz4pQUlVQ05DQDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LTI1OD
	4kMy41OjVBQlVCSk5APyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QUtVS0
	ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMjUkMz
	46Pz4pQU9VS0tJQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTk
	tBS1VLQDIrJE4kNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyQvND86IiQ4NS8kSyRKS0tBS1VMSk1AMi
	skSiQzNC4pJDg1LyRLJEpLS0FLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSU
	tKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENO
	Tk1JTktMSUpIVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUpJSUI3V1kSC1lBWUlJSVVJT0tVSkxMVUhPWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>

Li Wang (2):
  ceph: Clean up if error occurred in finish_read()
  ceph: Add necessary clean up if invalid reply received in
    handle_reply()

 fs/ceph/addr.c        |    3 +++
 net/ceph/osd_client.c |    7 +++++++
 2 files changed, 10 insertions(+)

-- 
1.7.9.5

