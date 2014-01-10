Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbaAJUZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:25:41 -0500
Received: from forward15.mail.yandex.net ([95.108.130.119]:44659 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaAJUZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:25:38 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: linux-kernel@vger.kernel.org
In-Reply-To: <70061389380178@web5j.yandex.ru>
Subject: Fwd: Waiting for programs to stop
MIME-Version: 1.0
Message-Id: <12671389385535@web5j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 10 Jan 2014 22:25:35 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I remind that we discuss sandboxing of untrusted programs.

My application needs to receive a signal when ALL direct and indirect children of a process (including this process itself) started in a sandbox exit (it should work even when they call setsid()).

You can assume that the sandboxing binary creates a new cgroup.

Can this be done with the current kernel?

--
Victor Porton - http://portonvictor.org
