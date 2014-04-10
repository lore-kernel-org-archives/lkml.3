Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaDJHIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:08:45 -0400
Received: from nm42.bullet.mail.ne1.yahoo.com ([98.138.120.49]:48400 "HELO
	nm42.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934241AbaDJHIn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:08:43 -0400
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 487272.52603.bm@omp1046.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hi42gMzT+b4CC87dg60EpBsl7TwUvo25KJAiumzIviGu9n+KZ+v/a2qdkg9q7jXznTcwJiTHR7DELu3jU6+WM0iXMrHzSGcajAMKzf4KFBwn1FafYagm1JMoPOXeygow7/lKbalJBIrXQ2OgB6PjYwfXGsAQDFSll3uWD0VT/mo=;
X-YMail-OSG: 2v07odoVM1myTMVGlN73XXYFdo6Zui.c789MfF8K2aMZIt9
 frD2KIm_8Q4gAPQQxkqFsz.NtNRnzh1Ge7jWdIbeH1VaoR.iY8EenLF0TjcO
 ZEvDk3BE7TbEWfl039q8RVMXcTB6O4_BrJ0nrVf5glfR5rsf3wNXEAZgfPwE
 TvbtNOuBb7ToVNGtZ3jehb4fObnBMxzE_fpOFHCBNI7f9ArdSj_JCnIPIiug
 AJR6iPrdGyZHD7tSFRH7UM2JQqr0EKKieXnevqiAGgrJM_lLZ6kHbFGCb_ok
 9_XVPrQ8xr4msvSCRx.M7ytwDhBAGeoQr_QpC4cuOD53gap7YkL3.USXKhgL
 IVwYoQpSyZuIQpW4Go.d4WOKJ6yw3oyQ7g7gS6v9fDJd2Qe34Qs9XbDt6S5D
 LjucUFyllGif3TW_jGXbecFlsspSigGDjXmhe6M7bagRDGDeHDQV2Hw1XSnE
 2juCsmmhLpUPCl91CcBgkdpGbpANWpslJn7ywlXne0hSjaHDuwflRJmbLY4P
 bXcRH8fHrRN48GUFNDY4KC2jVnmT3igN7PVxyMPczp.BCkI8xJqNf2Hm7b8M
 -
X-Rocket-MIMEInfo: 002.001,IEhpIEdyZWcvQWxsLCANCiAgwqAgDQogVGhpcyBpcyBOYXJhc2ltaGFyYW8gd29ya2luZyBmb3IgYSBzL3djb21wYW55IEhDTFQuLiANCiAgwqAgDQogSSBhbSB3b3JraW5nIGEgaXNzdWUgYW5kDQogdGhlIGRlc2NyaXB0aW9uIGlzIGJlbG93OiANCiAgwqAgDQogc3lzdGVtIHN0b3BzIGJvb3RpbmcgYW5kDQogbmVlZHMgYSBzZXJpZXMgb2YgY29uc29sZSBpbnB1dHMgKHNwYWNlIGJhciBvciByZXR1cm4pIHRvDQogY29udGludWUgYm9vdGluZy4gRWFjaCBpbnB1dCBhZHZhbmNlcyB0aGUgcHJvY2VzcyBhIGwBMAEBAQE-
X-Mailer: YahooMailClassic/481 YahooMailWebService/0.8.182.648
Message-ID: <1397113552.75117.YahooMailBasic@web160504.mail.bf1.yahoo.com>
Date: Thu, 10 Apr 2014 00:05:52 -0700 (PDT)
From: narasimharo bolisetti <nrbolisetti@yahoo.com>
Subject: system hang
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        Narasimharao Bolisetti <narasimharao.b@hcl.com>
Cc: "nrbolisetti@gmail.com" <nrbolisetti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
In-Reply-To: <62C418AB752FEF4D931AB8E89E46539F02878DFC@chn-hclt-mbs06.HCLT.CORP.HCL.IN>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Greg/All, 
    
 This is Narasimharao working for a s/wcompany HCLT.. 
    
 I am working a issue and
 the description is below: 
    
 system stops booting and
 needs a series of console inputs (space bar or return) to
 continue booting. Each input advances the process a little
 bit. 
 Actually I am trying to
 upgrade the s/w from usb pendrive, part of this upgrade
 having multiple times we are disconnecting and connecting
 the usb pen drive. 
    
 system stops booting and
 needs a series of console inputs (space bar or return) to
 continue booting. Each input advances the process a little
 bit. 
 I have tried to find the
 root cause for the issue but not get success, can you help
 me regarding to this what is the root cause and how i can
 fix this? 
    
 One more thing i observed
 that the space allocated for tty by 'tty_write_room'
 is suddenly consumed by more than 2k at the time of issue
 occurs and gradually
  
 consuming remaining memory
 and when reaches to zero upgrade completely hangs and when
 console inputs (space bar or return) to continue booting,
  
 Each input advances the
 process a little bit. This console i/p's creating some
 space for the same . Is this problem in tty?
  
 one more thing we observed
 that whenever we increase the logging then this problem
 happens regularly. 
    
 [   66.233676]
 EXT3-fs (sda14): using internal journal 
 [   66.233691]
 EXT3-fs (sda14): mounted filesystem with ordered data
 mode                             
  
 [   76.822878]
 par.que...par_queue_user_receive: Freeze check =0 
 [   76.828711]
 par.que...par_queue_user_receive: <*> returned
 -ERESTARTSYS <*> event =-512 
 [   76.837241]
 par_ldisc_open:record is found for ttyS4 
 [   76.842766]
 par.que...par_queue_user_receive: Freeze check =0 
 [   76.848594]
 par.que...par_queue_user_receive: <*> returned
 -ERESTARTSYS <*> event =-512 
 [  101.781654] usb
 1-1.3: USB disconnect, address 3 
 [  104.029178] usb
 1-1.3: new high speed USB device using fsl-ehci and address
 4 
 [  104.159085] scsi2
 : usb-storage 1-1.3:1.0 
 [  105.163726] scsi
 2:0:0:0: Direct-Access     Kingston
 DataTraveler 2.0 1.00 PQ: 0 ANSI: 2 
 [  105.173202] sd
 2:0:0:0: Attached scsi generic sg1 type 0 
 [  105.173686] sd
 2:0:0:0: [sdb] 4006912 512-byte logical blocks: (2.05
 GB/1.91 GiB) 
 [  105.174177] sd
 2:0:0:0: [sdb] Write Protect is off 
 [  105.174188] sd
 2:0:0:0: [sdb] Mode Sense: 23 00 00 00 
 [  105.174197] sd
 2:0:0:0: [sdb] Assuming drive cache: write through 
 [  105.178804] sd
 2:0:0:0: [sdb] Assuming drive cache: write through 
 [  105.178825] 
 sdb: sdb1 
 [  105.295052] sd
 2:0:0:0: [sdb] Assuming drive cache: write through 
 [  105.301142] sd
 2:0:0:0: [sdb] Attached SCSI removable
 disk                      
 - Hangs at this place and
 console i/p’s to continue booting. 
    
 I have tried with
 different sizes and different vendors pen drives but problem
 is the same and occurs at the same place. 
    
 Your valuable inputs and
 suggetions are helpful to fix this issue. 
    
 My kernel version is:
 2.6.35.6-45.fc14.i686 
    
 Thanks in advance for
 helping and replying. 
    
    
 Regards, 
 Narasimharao B 
    
    
    
    
    
 
 
 
 
 ::DISCLAIMER::
 ----------------------------------------------------------------------------------------------------------------------------------------------------
 The contents of
 this e-mail and any attachment(s) are confidential and
 intended for the named recipient(s) only.
 E-mail transmission is not guaranteed to be secure or
 error-free as information could be intercepted, corrupted, 
 lost, destroyed, arrive late or incomplete, or may contain
 viruses in transmission. The e mail and its contents 
 (with or without referred errors) shall therefore not attach
 any liability on the originator or HCL or its affiliates. 
 Views or opinions, if any, presented in this email are
 solely those of the author and may not necessarily reflect
 the 
 views or opinions of HCL or its affiliates. Any form of
 reproduction, dissemination, copying, disclosure,
 modification, 
 distribution and / or publication of this message without
 the prior written consent of authorized representative of 
 HCL is strictly prohibited. If you have received this email
 in error please delete it and notify the sender immediately.
 
 Before opening any email and/or attachments, please check
 them for viruses and other defects.
 ----------------------------------------------------------------------------------------------------------------------------------------------------
 
 
