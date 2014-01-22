Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaAVU5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:57:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaAVU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:57:18 -0500
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Chris Mason <clm@fb.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "mgorman\@suse.de" <mgorman@suse.de>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "lsf-pc\@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going beyond 4096 bytes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	<20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	<20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	<20140122151913.GY4963@suse.de>
	<1390410233.1198.7.camel@ret.masoncoding.com>
	<1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	<1390413819.1198.20.camel@ret.masoncoding.com>
	<1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
	<52E00B28.3060609@redhat.com>
	<1390415703.2372.62.camel@dabdike.int.hansenpartnership.com>
	<52E0106B.5010604@redhat.com>
	<1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 22 Jan 2014 15:57:01 -0500
In-Reply-To: <1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Wed, 22 Jan 2014 11:30:19 -0800")
Message-ID: <yq1y527ag6a.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> or even (not today, but some day) reject the IO.

James> I really doubt this.  All 4k drives today do RMW ... I don't see
James> that changing any time soon.

All consumer grade 4K phys drives do RMW.

It's a different story for enterprise drives. The vendors appear to be
divided between 4Kn and 512e with RMW mitigation.

-- 
Martin K. Petersen	Oracle Linux Engineering
