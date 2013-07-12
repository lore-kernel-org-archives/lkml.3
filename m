Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3GLROd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab3GLROc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:14:32 -0400
Date: Fri, 12 Jul 2013 13:14:22 -0400
From: Dave Jones <davej@redhat.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops mystery
Message-ID: <20130712171422.GC1537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steve Wise <swise@opengridcomputing.com>,
	linux-kernel@vger.kernel.org
References: <51E02545.7080106@opengridcomputing.com>
 <20130712164816.GE1020@redhat.com>
 <51E0348A.2030208@opengridcomputing.com>
 <20130712170046.GB1537@redhat.com>
 <51E03809.5030307@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E03809.5030307@opengridcomputing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:08:25PM -0500, Steve Wise wrote:
 
 > There is no 'Code:' line in the log.  I thought about that that too, but 
 > I don't see it dumping the code.   The kernel is a SLES11sp1 kernel, 
 > 1.6.32.54-0.3-default.
 
"Ask suse" is probably your best bet in that case.

 > [ 1054.392502] Modules linked in: smb2(N) smb(N) smb_manager(N) 
 > nas_netlink(N) af_packet nfsd nfs_common(N) lockd auth_rpcgss nas_acl(N) 
 > nas_proto_vfs(N) sunrpc snas_ts(N) ipmi_devintf snas_cafs(PN) snas_ca(N) 
 > ipmi_si ipmi_msghandler snas_mds(PN) snas_ds(N) nm(PN) snas_nvcache(PN) 
 > snas_dlm(PN) snas_trns(PN) snas_cm_sdd(PN) snas_cm_pma(PN) 
 > disk_online_diagnostic(N) snas_monc(N) snas_fc(N) snas_mml(PN) cstl(PN) 
 > ptlrpc(N) ko2iblnd(N) ksocklnd(N) obdclass(N) lnet(N) lvfs(PN) libcfs(N) 
 > snas_base(PN) nofs(N) usos(N) zlib_deflate cpufreq_conservative 
 > cpufreq_userspace cpufreq_powersave acpi_cpufreq t3k_mpt2sas_vdl(N) 
 > raidrepair(N) ib_ipoib ib_umad iw_nes crc32c libcrc32c iw_cxgb3 cxgb3 
 > ib_qib(N) dca mlx4_ib mlx4_en mlx4_core ib_mthca nvdimm_mapping(N) 
 > smbuspci(N) microcode t4_tom(N) toecore(N) rdma_ucm ib_uverbs rdma_cm 
 > ib_cm iw_cm ib_sa ib_mad ib_addr ipv6 iw_cxgb4(N) ib_core 
 > soft_watchdog(PN) kbox(PN) fuse loop dm_mod tpm_tis tpm iTCO_wdt 
 > rtc_cmos tpm_bios i2c_i801 cxgb4(N) pcspkr iTCO_vendor_support i2c_core 
 > rtc_core ses sg rtc_lib bnx2 enclosure wmi button container usbhid hid 
 > ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan processor 
 > mpt2sas scsi_transport_sas raid_class scsi_mod thermal thermal_sys hwmon 
 
Or maybe one of the proprietary module vendors. Who knows.

	Dave

