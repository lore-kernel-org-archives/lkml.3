Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3CTCyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:54:44 -0400
Received: from [219.239.227.113] ([219.239.227.113]:2400 "EHLO
	mail.act.buaa.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3CTCyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:54:43 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 22:54:42 EDT
From: "ZHANG, Benlong" <zhangbl@act.buaa.edu.cn>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Mar 2013 10:49:15 +0800
Subject: =?windows-1256?Q?How_to_implement_a_system_call_in_3.8.2=FE?=
Thread-Topic: =?windows-1256?Q?How_to_implement_a_system_call_in_3.8.2=FE?=
Thread-Index: AQHOJRWCI7xW4jW+VUOuWAVWTGwHKQ==
Message-ID: <835012AB67A67C408EEFBCCCC906381E02269C0BE2DA@mail.lab.act.buaa.edu.cn>
Accept-Language: zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the title indicates, I want to know  how to add
a system call under the source code of version 3.8.2,
As It really puzzles me a lot on how the sys_call_table
get initialized,

Thanks.
------------------------------------------------------
