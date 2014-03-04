Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaCDPPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:15:17 -0500
Received: from [207.46.163.210] ([207.46.163.210]:43580 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932111AbaCDPPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:15:15 -0500
From: Jason Zhu <jzhu@xceedium.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Kernel Panic on Kernel 2.6.36.1
Thread-Topic: Kernel Panic on Kernel 2.6.36.1
Thread-Index: AQHPN7x0SBHz83ysvEabvwaFbRO1Uw==
Date: Tue, 4 Mar 2014 15:14:35 +0000
Message-ID: <7a37f54158514d80971d22947a74341c@BY2PR08MB347.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.35.96.194]
x-forefront-prvs: 01401330D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(5423002)(81342001)(76482001)(76176001)(77982001)(74706001)(74366001)(95666003)(54356001)(50986001)(53806001)(59766001)(66066001)(51856001)(63696002)(74876001)(74316001)(80022001)(46102001)(76576001)(76786001)(76796001)(4396001)(47976001)(79102001)(49866001)(56776001)(47736001)(77096001)(65816001)(54316002)(81542001)(94946001)(86362001)(95416001)(94316002)(93136001)(85306002)(83072002)(2656002)(87266001)(85852003)(87936001)(92566001)(33646001)(93516002)(69226001)(31966008)(74502001)(90146001)(56816005)(74662001)(83322001)(81816001)(80976001)(81686001)(47446002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR08MB314;H:BY2PR08MB347.namprd08.prod.outlook.com;CLIP:108.35.96.194;FPR:C02BEA7C.2F325009.A2D75288.40027E8D.202E5;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: xceedium.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24FFPmH004469

Hello,

I have had two separate instances of kernel panics on the 2.6.36.1 kernel. I do not have the expertise necessary to interpret the traces and I would like to see if there is anyone who can explain what the traces are saying so that I may get some insight as to the cause of the issue.Â 

Â [<ffffffff8104866c>] ? wake_bit_function+0x0/0x23Â 
Â [<ffffffff8104855f>] ? bit_waitqueue+0x10/0xa0Â 
Â [<ffffffff8104862d>] ? wake_up_bit+0x11/0x22Â 
Â [<ffffffff810eeb38>] ? ext3_handle_error+0xb3/0xb7Â 
Â [<ffffffff810eeb99>] ? __ext3_std_error+0x5d/0x64Â 
Â [<ffffffff810ec550>] ? ext3_orphan_add+0x165/0x176Â 
Â [<ffffffff810e5b63>] ? walk_page_buffers+0x67/0x8dÂ 
Â [<ffffffff810e74b9>] ? journal_dirty_data_fn+0x0/0x16Â 
Â [<ffffffff810e8fea>] ? ext3_ordered_write_end+0xc5/0x10fÂ 
Â [<ffffffff8106a08d>] ? generic_file_buffered_write+0x16f/0x22cÂ 
Â [<ffffffff8106b9af>] ? __generic_file_aio_write+0x33b/0x36fÂ 
Â [<ffffffff8106bf9a>] ? generic_file_aio_read+0x51e/0x5b7Â 
Â [<ffffffff8108770e>] ? page_add_new_anon_rmap+0x65/0x86Â 
Â [<ffffffff8106ba36>] ? generic_file_aio_write+0x53/0x99Â 
Â [<ffffffff81099b44>] ? do_sync_write+0xb0/0xf2Â 
Â [<ffffffff81006df0>] ? __switch_to+0x1dd/0x2a4Â 
Â [<ffffffff81008a8e>] ? apic_timer_interrupt+0xe/0x20Â 
Â [<ffffffff8100e929>] ? read_tsc+0xa/0x20Â 
Â [<ffffffff8109a3c9>] ? vfs_write+0xad/0x134Â 
Â [<ffffffff8109a50c>] ? sys_write+0x45/0x6eÂ 
Â [<ffffffff81026bac>] ? sysenter_dispatch+0x7/0x32

Â [<ffffffff813c6336>] ? panic+0x9d/0x1a4Â 
Â [<ffffffff813c648b>] ? printk+0x4e/0x56Â 
Â [<ffffffff810ee546>] ? ext3_abort+0x95/0xffÂ 
Â [<ffffffff812c7787>] ? __sk_free+0xd7/0xedÂ 
Â [<ffffffff81357208>] ? unix_destruct_scm+0xb2/0xb9Â 
Â [<ffffffff812ccedb>] ? memcpy_toiovec+0x34/0x62Â 
Â [<ffffffff810f0230>] ? ext3_journal_start_sb+0x32/0x4aÂ 
Â [<ffffffff810e6610>] ? ext3_dirty_inode+0x28/0x7bÂ 
Â [<ffffffff810b376a>] ? __mark_inode_dirty+0x27/0x1adÂ 
Â [<ffffffff810aac50>] ? file_update_time+0x100/0x12fÂ 
Â [<ffffffff8106b8cf>] ? __generic_file_aio_write+0x25b/0x36fÂ 
Â [<ffffffff810a88e6>] ? dput+0x37/0x152Â 
Â [<ffffffff8106ba36>] ? generic_file_aio_write+0x53/0x99Â 
Â [<ffffffff8106b9e3>] ? generic_file_aio_write+0x0/0x99Â 
Â [<ffffffff81099a50>] ? do_sync_readv_writev+0x9a/0xdeÂ 
Â [<ffffffff810a47b3>] ? user_path_at+0x59/0x7fÂ 
Â [<ffffffff81006df0>] ? __switch_to+0x1dd/0x2a4Â 
Â [<ffffffff810cb4ae>] ? compat_do_readv_writev+0xe9/0x1b1Â 
Â [<ffffffff810279fe>] ? sys32_stat64+0x20/0x29Â 
Â [<ffffffff810cb682>] ? compat_sys_writev+0x64/0x8dÂ 
Â [<ffffffff81026bac>] ? sysenter_dispatch+0x7/0x32â€‹

Let me know if you need any additional details.

Please C.C. me in any further answers/discussions for this question.Â 

Regards,
Jasonâ€‹


 ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
