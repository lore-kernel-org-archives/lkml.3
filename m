Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaJTReY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:34:24 -0400
Received: from mout.gmx.net ([212.227.17.22]:57836 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaJTReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:34:23 -0400
Message-ID: <5445479C.4030201@gmx.de>
Date: Mon, 20 Oct 2014 19:34:20 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: v3.18-rc1 32 bit KVM hangs early in boot process
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7kdDdNWFA4qgFo7cI7IgXsnSGlFhpZXNw6KFtCou57by1upBvgL
 iHp0pNNSfQghl/aS6F5XKDIVXkTkK4grEi2JxUrMboGSs9B6sXDUqhuxnj+CuXoleV10zn9
 jElf6Z2M31RqQ7RDIjgQGil1zqLovqUjhcUM1AxUD6Wgdd4KoWHz2aPhZhKTYbjKXXT2e1x
 SvXAiLLUHBF+30DDW2F5Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I uploaded the screen shots from the virt-manager to [1] and [2]

FWIW e56d9fccb was fine so the bug slipped in after that.

(The term "fine" is exceptional to this already reported issue :

$> modprobe nf_reject_ipv4
modprobe: ERROR: could not insert 'nf_reject_ipv4': Unknown symbol in module, or unknown parameter (see dmesg)

$> tail /var/log/messages
Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol rcu_read_lock_bh_held (err 0)
Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol ip_local_out_sk (err 0)
Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol rcu_read_lock_held (err 0)

)


[1] http://www.directupload.net/file/d/3781/j9mwrtpq_jpg.htm
[2] http://www.directupload.net/file/d/3781/29trc56v_jpg.htm

-- 
Toralf
pgp key: 0076 E94E

