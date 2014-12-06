Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaLFXEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 18:04:35 -0500
Received: from message.langara.bc.ca ([209.87.29.115]:47905 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaLFXEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 18:04:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <fb6de63ae8d.54838b80@langara.bc.ca>
Date: Sat, 06 Dec 2014 23:04:32 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: How can I parse the command name from /proc/<pid>/stat?
X-Accept-Language: en
In-reply-to: <54818A4B.60100@arm.com>
References: <fc15da367389.5480b999@langara.bc.ca> <54818A4B.60100@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, I dislike the idea of relying upon stat never gaining any other part
that uses ) but that would work instead of using status.
