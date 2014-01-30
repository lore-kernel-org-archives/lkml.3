Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaA3DVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 22:21:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaA3DVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 22:21:22 -0500
Message-ID: <52E9C525.6000603@vlnb.net>
Date: Wed, 29 Jan 2014 19:21:09 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ANNOUNCE]: SCST iSER target driver is available for testing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:LSx8gWouU88AxByd1waPItdER0L3kdlP4F/VzmT7yD6
 66qa5vyyrt86Vs3NTXVJtJ1v4SXrf4mcgaKsvhtKFTn+AmKrSj
 X3iSc2XNon+oeiUtLu7LoNn+B0WytLaNQ7qsCgIMLJ/IlQHE9E
 AHMfzte8I4de2wnuVb/+hTLgsXBNKHJsDVkyAaeuYgGa96xWPf
 21zSFjqGztqYzOovfmPWwQiVDqo1MQNneMLOhqgtY6kVHrxhXq
 wlzJ0s4CMsidOh7fkILylb3kv74qLoOo2iCiqDdLtInGtD923h
 wZhARVR7fajC+JM48FADUwE5tATV0cO7ftdVtN3F+PEubiAvaD
 jaeja7GyP1vMTqcZn874=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce that SCST iSER target driver is available for testing from the SCST SVN iser branch. You can download it either by command:

$ svn checkout svn://svn.code.sf.net/p/scst/svn/branches/iser iser-scst-branch

or by clicking on "Download Snapshot" button on http://sourceforge.net/p/scst/svn/HEAD/tree/branches/iser page.

Big thanks to Yan Burman and Mellanox Technologies who developed it!

SCST is SCSI target mode stack for Linux. SCST allows creation of sophisticated storage devices, which provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Majority of recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Vlad
