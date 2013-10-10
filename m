Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3JJQkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:40:52 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:38065 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3JJQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:40:50 -0400
Date: Thu, 10 Oct 2013 18:39:55 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-kernel@vger.kernel.org
Subject: tracing SCSI commands over SATA
Message-ID: <20131010163955.GA13337@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to record all SCSI commands/status for a SATA DVD drive.
Right now I am using a USB<>SATA bridge and wireshark on usbmon.

Q: Can something similar be done without having to go over USB?

I am interested only about the SCSI commands sent to a particular
SATA drive and resulting status codes and also timing.

...looking for possible causes why a few drives are locking up for
10..20 minutes on DVD+RW packet writing on UDF and then continue like
nothing happened. (linux tries hard to reset but the drives dont accept
any commands until the 10..20 minutes are over), not even  INQUIRE, nothing.

Karl


