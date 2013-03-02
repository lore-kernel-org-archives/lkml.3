Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CBMC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 07:02:57 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4881 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3CBMC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 07:02:56 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5131EA60.40607@broadcom.com>
Date: Sat, 2 Mar 2013 13:02:40 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Andy Whitcroft" <apw@canonical.com>, "Joe Perches" <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: checkpatch bailing out
X-WSS-ID: 7D2F361C3S46039131-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With my laptop being broken I have to work on a server provided by my 
employer and I am preparing some patches for submission. So I intended 
to run checkpatch, but I get the following message after which the 
script bails out:

$ git format-patch -1 --stdout | scripts/checkpatch.pl -
Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- 
HERE |(?-1))*\))/ at scripts/checkpatch.pl line 347.

The server runs RHEL5

2.6.18-308.20.1.el5 #1 SMP x86_64 GNU/Linux

Perl interpreter:

$ /usr/bin/perl -v

This is perl, v5.8.8 built for x86_64-linux-thread-multi

My repository is based on wireless-testing repo.

Did a quick search on LKML, but not finding anything like this. Any help 
would be appreciated here.

Gr. AvS

