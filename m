Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaBLRf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:35:29 -0500
Received: from adamg.eu ([91.192.224.99]:48487 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaBLRf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:35:26 -0500
X-Greylist: delayed 1109 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 12:35:26 EST
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Reply-To: pawel.sikora@agmk.net
Subject: [3.13.2] list passed to list_sort() too long for efficiency.
Date: Wed, 12 Feb 2014 18:16:49 +0100
Message-ID: <1799469.xr2i5c36Hj@localhost.localdomain>
User-Agent: KMail/4.12.2 (Linux/3.12.10-300.fc20.x86_64; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i've noticed on my server that dmesg contains following info:

(...)
[  141.192868] FS-Cache: Loaded
[  141.203008] FS-Cache: Netfs 'nfs' registered for caching
[ 1383.278845] Key type dns_resolver registered
[ 1383.293014] NFS: Registering the id_resolver key type
[ 1383.293027] Key type id_resolver registered
[ 1383.293028] Key type id_legacy registered
[ 3998.115273] perf samples too long (2502 > 2500), lowering 
kernel.perf_event_max_sample_rate to 50100
[16855.582522] list passed to list_sort() too long for efficiency

could someone put some light on the last line?

BR,
Paweł.

please CC on reply.

-- 
gpg key fingerprint = 60B4 9886 AD53 EB3E 88BB 1EB5 C52E D01B 683B 9411
