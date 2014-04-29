Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbaD2Oz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:55:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46490 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaD2OzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:55:25 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nick Swenson <nks@daterainc.com>
Subject: [PATCH 0/3] percpu_ida: support to export allocation/free information
Date: Tue, 29 Apr 2014 22:53:50 +0800
Message-Id: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches support to export percpu_ida allocation/free information
via sysfs, so that percpu_ida performance can be monitored, and
at least two use cases:

- some parameters(such as percpu_max_size) from its users are very
sensitive to performance

- the data is helpful for verifying patches which try to improve
percpu_ida


Thanks,
--
Ming Lei

