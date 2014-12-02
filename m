Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaLBVYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:24:43 -0500
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:33336 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932692AbaLBVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:24:41 -0500
Message-Id: <20141202212429.996456533@linux.com>
Date: Tue, 02 Dec 2014 15:24:29 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] percpu: Consistent per cpu operations: The final edition
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes the last leftovers of __get_cpu_var in the kernel.
It updates the documentation and then removes the macros.


