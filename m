Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab3CTTDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:03:36 -0400
Received: from mail-la0-f67.google.com ([209.85.215.67]:48054 "EHLO
	mail-la0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3CTTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:03:35 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 11:45:32 -0700
Message-ID: <CAEtk5ge3MBn5759EfUVdNRmb2g=kvtbe7u+xkZXy5E0KoynoJw@mail.gmail.com>
Subject: Workqueue behaviour - Synchronization within submitted work.
From: Vijay <thelonejoker@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the new workqueue architecture, I have a question regarding
synchronization between different "work" submitted to the same
workqueue. For example:

* I submit two "works" A and B to a common driver specific workqueue (W).
* Each A and B, meddle with a certain shared data SD.
* Am I guaranteed serialized execution of A and B, or should I play
safe and use a semaphore (acquire/release) with A and B ?

Thanks,
Vijay
