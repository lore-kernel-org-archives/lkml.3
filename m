Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbbA0NI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:08:56 -0500
Received: from mail1.vodafone.ie ([213.233.128.43]:61807 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbA0NIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:08:53 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 08:08:53 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswFABGLx1RtTdKd/2dsb2JhbABagwaBDoE/gV61A5VyQwEBAQEBfYQ2DwFuDQIFFgsCCwMCAQIBSwEMCAEBiCwBvxiFaY9FgSGRRoFBBZkkhTULg0uIHCKBRQwBghw+gnMBAQE
Message-ID: <54C78B8F.9090903@draigBrady.com>
Date: Tue, 27 Jan 2015 12:58:55 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, aneesh.kumar@linux.vnet.ibm.com,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: RFC: More functions allowed with O_PATH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fsync(), fdatasync(), syncfs() work on an identifying descriptor,
and all work against a read-only file for example,
should any/all these functions work with a descriptor opened with O_PATH ?

thanks,
Pádraig.
