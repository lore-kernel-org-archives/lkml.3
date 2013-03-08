Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3CHCnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:43:31 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64392 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab3CHCna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:43:30 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 7 Mar 2013 18:43:08 -0800
X-Google-Sender-Auth: fubTffhKwusLe0rMfrMjGoFds8Q
Message-ID: <CAB=NE6WWBfwVLhtf8H4Yorhiy_cU+tkLg-NbXTGj3nOgcvYF2w@mail.gmail.com>
Subject: [ANN] compat-drivers-3.9-rc1 releases
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus kicked out v3.9-rc1, the first respective backport of this
release's 802.11, Bluetooth, Ethernet and DRM subsystems down to the
last 30 kernel releases is now available at:

https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.9-rc1/

ckmake test compile results of these releases against the last 30
vanilla kernels:

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.50              [  OK  ]
18  3.0.65              [  OK  ]
19  3.1.10              [  OK  ]
20  3.2.33              [  OK  ]
21  3.2.38              [  OK  ]
22  3.3.8               [  OK  ]
23  3.4.17              [  OK  ]
24  3.4.32              [  OK  ]
25  3.5.7               [  OK  ]
26  3.6.11              [  OK  ]
27  3.6.5               [  OK  ]
28  3.7.0               [  OK  ]
29  3.7.9               [  OK  ]
30  3.8.0               [  OK  ]

  Luis
