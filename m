Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3HZEMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:12:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56903 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3HZEMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:12:10 -0400
Message-ID: <12D837ECDEC84883A6B388BBA1B21E72@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
To: <james.bottomley@hansenpartnership.com>,
        "linux-scsi" <linux-scsi@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: <billion@areca.com.tw>
Subject: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
Date: Mon, 26 Aug 2013 12:12:19 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Antivirus: avast! (VPS 130825-1, 2013/08/26), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching <ching2048@areca.com.tw>


Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
Modify maximum outstanding command number, notify command complete with auto 
request sense
Signed-off-by: Ching  <ching2048@areca.com.tw>

