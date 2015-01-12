Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbbALCdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 21:33:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:19826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbALCdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 21:33:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="439292785"
Message-ID: <1421029988.6201.150.camel@intel.com>
Subject: [LKP] [drm/radeon] 38c2adfb00d: Fixed kernel panic
From: Huang Ying <ying.huang@intel.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Mon, 12 Jan 2015 10:33:08 +0800
Content-Type: multipart/mixed; boundary="=-m4tEZ8t+bQSE4z+J/Ahz"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m4tEZ8t+bQSE4z+J/Ahz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

FYI, we noticed the below changes on

commit 38c2adfb00db045a876dd667040abc01b788ad61 ("drm/radeon: Init amdkfd only if it was compiled")

The original kernel panic caused by radeon init is fixed!  Thanks!

testbox/testcase/testparams: vm-vp-quantal-i386/boot/1

68d0cb49f8db5ddc  38c2adfb00db045a876dd66704  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :10         100%          10:10    kmsg.dummy-irq:no_IRQ_given.Use_irq=N
           :10         100%          10:10    kmsg.mk712:device_not_present
           :10         100%          10:10    kmsg.wistron_btns:System_unknown
           :10         100%          10:10    kmsg.ideapad_slidebar:DMI_does_not_match
           :10         100%          10:10    kmsg.i2c-parport-light:adapter_type_unspecified
           :10         100%          10:10    kmsg.i2c_i2c-#:detect_fail:address_match
           :10         100%          10:10    kmsg.pc87360:PC8736x_not_detected,module_not_inserted
           :10         100%          10:10    kmsg.sch56xx_common:Unsupported_device_id
           :10         100%          10:10    kmsg.acquirewdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.wafer5823wdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.i6300esb:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.pc87413_wdt:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.sbc60xxwdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.sbc8360:failed_to_register_misc_device
           :10         100%          10:10    kmsg.sbc7240_wdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.cpu5wdt:misc_register_failed
           :10         100%          10:10    kmsg.w83877f_wdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.sbc_epx_c3:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.Driver'mmcblk'needs_updating-please_use_bus_type_methods
           :10         100%          10:10    kmsg.vme_user:No_cards,skipping_registration
           :10         100%          10:10    kmsg.dell_wmi:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.dell_wmi_aio:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.acer_wmi:No_or_unsupported_WMI_interface,unable_to_load
           :10         100%          10:10    kmsg.acerhdf:error_getting_hardware_information
           :10         100%          10:10    kmsg.alienware_wmi:alienware-wmi:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.fmc_fake-design-for-testing-f001:Driver_has_no_ID:matches_all
           :10         100%          10:10    kmsg.fmc_write_eeprom_fake-design-for-testing-f001:fmc_write_eeprom:no_busid_passed,refusing_all_cards
           :10         100%          10:10    kmsg.intel_rapl:no_valid_rapl_domains_found_in_package
         10:10        -100%            :10    kmsg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    kmsg.Oops
         10:10        -100%            :10    kmsg.Kernel_panic-not_syncing:Fatal_exception
         10:10        -100%            :10    kmsg.Kernel_Offset:#from#(relocation_range:#-#)
         10:10        -100%            :10    dmesg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    dmesg.Oops
         10:10        -100%            :10    dmesg.Kernel_panic-not_syncing:Fatal_exception

testbox/testcase/testparams: vm-kbuild-yocto-i386/boot/1

68d0cb49f8db5ddc  38c2adfb00db045a876dd66704  
----------------  --------------------------  
           :10         100%          10:10    kmsg.dummy-irq:no_IRQ_given.Use_irq=N
           :10         100%          10:10    kmsg.dummy-irq:no_IRQ_given.Use_irq=N
           :10         100%          10:10    kmsg.wistron_btns:System_unknown
           :10         100%          10:10    kmsg.i2c-parport-light:adapter_type_unspecified
           :10         100%          10:10    kmsg.i2c-parport-light:adapter_type_unspecified
           :10         100%          10:10    kmsg.pc87360:PC8736x_not_detected,module_not_inserted
           :10         100%          10:10    kmsg.sch56xx_common:Unsupported_device_id
           :10         100%          10:10    kmsg.i6300esb:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.pc87413_wdt:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.sbc60xxwdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.sbc8360:failed_to_register_misc_device
           :10         100%          10:10    kmsg.sbc7240_wdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.cpu5wdt:misc_register_failed
           :10         100%          10:10    kmsg.w83877f_wdt:I/O_address#already_in_use
           :10         100%          10:10    kmsg.sbc_epx_c3:cannot_register_miscdev_on_minor=#(err=-#)
           :10         100%          10:10    kmsg.dell_wmi:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.dell_wmi_aio:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.acer_wmi:No_or_unsupported_WMI_interface,unable_to_load
           :10         100%          10:10    kmsg.acerhdf:error_getting_hardware_information
           :10         100%          10:10    kmsg.alienware_wmi:alienware-wmi:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.alienware_wmi:alienware-wmi:No_known_WMI_GUID_found
           :10         100%          10:10    kmsg.fmc_fake-design-for-testing-f001:Driver_has_no_ID:matches_all
           :10         100%          10:10    kmsg.fmc_fake-design-for-testing-f001:Driver_has_no_ID:matches_all
           :10         100%          10:10    kmsg.fmc_write_eeprom_fake-design-for-testing-f001:fmc_write_eeprom:no_busid_passed,refusing_all_cards
           :10         100%          10:10    kmsg.fmc_write_eeprom_fake-design-for-testing-f001:fmc_write_eeprom:no_busid_passed,refusing_all_cards
         10:10        -100%            :10    kmsg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    kmsg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    kmsg.Oops
         10:10        -100%            :10    kmsg.Oops
         10:10        -100%            :10    kmsg.Kernel_panic-not_syncing:Fatal_exception
         10:10        -100%            :10    kmsg.Kernel_panic-not_syncing:Fatal_exception
         10:10        -100%            :10    kmsg.Kernel_Offset:#from#(relocation_range:#-#)
         10:10        -100%            :10    kmsg.Kernel_Offset:#from#(relocation_range:#-#)
         10:10        -100%            :10    dmesg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    dmesg.BUG:unable_to_handle_kernel
         10:10        -100%            :10    dmesg.Oops
         10:10        -100%            :10    dmesg.Oops
         10:10        -100%            :10    dmesg.Kernel_panic-not_syncing:Fatal_exception
         10:10        -100%            :10    dmesg.Kernel_panic-not_syncing:Fatal_exception
           :10         100%          10:10    kmsg.drm/i810_does_not_support_SMP
           :10         100%          10:10    kmsg.nandsim]warning:read_byte:unexpected_data_output_cycle,state_is_STATE_READY_return
           :10         100%          10:10    kmsg.nandsim]warning:read_byte:unexpected_data_output_cycle,state_is_STATE_READY_return
           :10         100%          10:10    kmsg.ks0108:ERROR:parport_didn't_register_new_device
           :10         100%          10:10    kmsg.cfag12864b:ERROR:ks0108_is_not_initialized
           :10         100%          10:10    kmsg.cfag12864bfb:ERROR:cfag12864b_is_not_initialized
           :10         100%          10:10    kmsg.pps_parport:couldn't_register_with_parport0
           :10         100%          10:10    kmsg.applesmc:supported_laptop_not_found
           :10         100%          10:10    kmsg.applesmc:driver_init_failed(ret=-#)
           :10         100%          10:10    kmsg.vmap_allocation_for_size#failed:use_vmalloc=<size>to_increase_size
           :10         100%          10:10    kmsg.null):enodev_DEV_ADDR=#xFF
           :10         100%          10:10    kmsg.toshiba_acpi:Unable_to_create_proc_dir_toshiba
           :10         100%          10:10    kmsg.mce:Unable_to_init_device/dev/mcelog(rc:-#)
           :10         100%          10:10    kmsg.mce:Unable_to_init_device/dev/mcelog(rc:-#)
           :10         100%          10:10    kmsg.Starting_Bootlog_daemon:bootlogd:cannot_allocate_pseudo_tty:No_such_file_or_directory
           :10         100%          10:10    kmsg.no_ifx_modem_active
           :10          10%           1:10    kmsg.APIC_calibration_not_consistent_with_PM-Timer:#ms_instead_of#ms
           :10         100%          10:10    kmsg.Failed_to_add_WC_MTRR_for[#-#];performance_may_suffer
           :10         100%          10:10    kmsg.mtdoops:mtd_device(mtddev=name/number)must_be_supplied
           :10         100%          10:10    kmsg.Warning!fusbh200_hcd_should_always_be_loaded_before_uhci_hcd_and_ohci_hcd,not_after
           :10         100%          10:10    kmsg.rtc(null):invalid_alarm_value
           :10         100%          10:10    kmsg.intel_powerclamp:Intel_powerclamp_does_not_run_on_family#model
           :10         100%          10:10    kmsg.geodewdt:No_timers_were_available
           :10         100%          10:10    kmsg.sc1200wdt:io_parameter_must_be_specified
           :10         100%          10:10    kmsg.acerhdf:unknown(unsupported)BIOS_version_Bochs/Bochs/Bochs,please_report,aborting
           :10         100%          10:10    kmsg.msi_wmi:This_machine_doesn't_have_neither_MSI-hotkeys_nor_backlight_through_WMI
           :10         100%          10:10    kmsg.ALSA:seq_oss:can't_register_device_seq
           :10         100%          10:10    kmsg.rcu-torture:Free-Block_Circulation

vm-vp-quantal-i386: qemu-system-i386 -enable-kvm -cpu Haswell,+smep,+smap
Memory: 360M

vm-kbuild-yocto-i386: qemu-system-i386 -enable-kvm
Memory: 320M


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Huang, Ying


--=-m4tEZ8t+bQSE4z+J/Ahz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-m4tEZ8t+bQSE4z+J/Ahz--

