Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaGTEvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:51:05 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44545 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaGTEvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:51:02 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 00:51:02 -0400
Message-ID: <CAPDOMVhvixp4+3P8RPUhM0iT_Ovo2kgPTUBorxPny9t_Fo2UUw@mail.gmail.com>
Subject: cciss_scsi.c: Fix me
From: Nick Krause <xerofoify@gmail.com>
To: mike.miller@hp.com
Cc: iss_storagedev@hp.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Mike,
I seem to be hitting a fix me message in this file in
function,cciss_scsi_queue_command_lck.
I am wondering what you want to do when C is Null?
Cheers Nick
