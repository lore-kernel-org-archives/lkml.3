Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3J1Vy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:54:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46018 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3J1VyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:54:25 -0400
Message-ID: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
Subject: scsi-mq + open-iscsi support patches..?
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Open iSCSI <open-iscsi@googlegroups.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Mon, 28 Oct 2013 15:03:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Just curious as to the status of the scsi-mq conversion patches for
open-iscsi that you where working on a while back..?

I'm asking because recently I've been spending alot of time with scsi-mq
+ virtio-scsi, and would really to start banging on iser-target ports
using an scsi-mq enabled iser-initiator as well..

So that said, are there any blockers holding things up towards getting a
working prototype..?

--nab

