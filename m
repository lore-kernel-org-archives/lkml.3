Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaAFW6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:58:47 -0500
Received: from mailuogwdur.emc.com ([128.221.224.79]:16126 "EHLO
	mailuogwdur.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaAFW6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:58:42 -0500
X-Greylist: delayed 1516 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 17:58:41 EST
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd51.lss.emc.com s06MXD1b001671
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd51.lss.emc.com s06MXD1b001671
From: "faibish, sorin" <faibish_sorin@emc.com>
To: Ric Wheeler <ricwheeler@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 17:32:56 -0500
Subject: RE: [LSF/MM TOPIC] [ATTEND] persistent memory progress, management
 of storage & file systems
Thread-Topic: [LSF/MM TOPIC] [ATTEND] persistent memory progress, management
 of storage & file systems
Thread-Index: Ac8LLo/YzlWvLrjoTLS8qnNu3ha0bAAAB+YA
Message-ID: <2512424DBC01FD48843E938C780FA97C02B002A583@MX23A.corp.emc.com>
References: <20131220093022.GV11295@suse.de> <52CB2C3A.3010207@gmail.com>
In-Reply-To: <52CB2C3A.3010207@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Sentrion-Hostname: mailusrhubprd53.lss.emc.com
X-RSA-Classifications: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speaking of persistent memory I would like to discuss the PMFS as well as RDMA aspects of the persistent memory model. Also I would like to discuss KV stores and object stores on persistent memory. I was involved in the PMFS as a tester and I found several issues that I would like to discuss with the community. I assume that maybe others from Intel could join this discussion except for Andy and Matt which already asked for this topic. Thanks

./Sorin

-----Original Message-----
From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On Behalf Of Ric Wheeler
Sent: Monday, January 06, 2014 5:21 PM
To: linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; linux-mm@kvack.org; linux-fsdevel@vger.kernel.org; lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [LSF/MM TOPIC] [ATTEND] persistent memory progress, management of storage & file systems


I would like to attend this year and continue to talk about the work on enabling the new class of persistent memory devices. Specifically, very interested in talking about both using a block driver under our existing stack and also progress at the file system layer (adding xip/mmap tweaks to existing file systems and looking at new file systems).

We also have a lot of work left to do on unifying management, it would be good to resync on that.

Regards,

Ric

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

